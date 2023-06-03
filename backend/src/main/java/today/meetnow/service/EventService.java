package today.meetnow.service;


import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.CoordinateSequence;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.impl.CoordinateArraySequence;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import today.meetnow.model.*;
import today.meetnow.model.dto.*;
import today.meetnow.model.enums.Type;
import today.meetnow.repository.*;

import javax.persistence.EntityNotFoundException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EventService {

    private final ParticipantRepository participantRepository;
    private final EventRepository eventRepository;
    private final HostRepository hostRepository;
    private final EventPostRepository eventPostRepository;
    private final UserService userService;
    public List<EventDto> getParticipatedEvents() {
        var currentUserId = userService.getCurrentUserId();

        return eventRepository.findAllByUserId(currentUserId)
                .stream()
                .map(this::convertToEventDto)
                .collect(Collectors.toList());
    }
    public EventDto convertToEventDto(EventEntity eventEntity) {
        Long eventId = eventEntity.getId();
        var optionalHostEntity = hostRepository.findByEventId(eventId);
        if (optionalHostEntity.isEmpty()) {
            throw new IllegalStateException("No host of event with id " + eventId);
        }
        var hostEntity = optionalHostEntity.get();
        var hostDto = convertToHostDto(hostEntity);

        List<ParticipantDto> participantDtoList = participantRepository.findAllByEventId(eventEntity.getId())
                .stream()
                .map(this::convertToParticipantDto)
                .collect(Collectors.toList());

        List<EventPostDto> eventPostDtoList = eventPostRepository.findAllByEventId(eventEntity.getId())
                .stream()
                .map(this::convertToEventPostDto)
                .collect(Collectors.toList());

        return EventDto.builder()
                .id(eventEntity.getId())
                .startDate(eventEntity.getStartDate())
                .endDate(eventEntity.getEndDate())
                .title(eventEntity.getTitle())
                .description(eventEntity.getDescription())
                .type(eventEntity.getType())
                .image(eventEntity.getImage())
                .coordinates(eventEntity.getCoordinates().getCoordinates()[0])
                .host(hostDto)
                .participants(participantDtoList)
                .posts(eventPostDtoList)
                .build();
    }
    public HostDto convertToHostDto(HostEntity hostEntity) {
        var hostPersonalData = userService.getUserPersonalData(hostEntity.getUser().getId());

        return HostDto.builder()
                .id(hostEntity.getId())
                .firstName(hostPersonalData.getFirstName())
                .lastName(hostPersonalData.getLastName())
                .image(hostPersonalData.getImage())
                .build();
    }
    private ParticipantDto convertToParticipantDto(ParticipantEntity participantEntity) {
        var personalData = userService.getUserPersonalData(participantEntity.getUser().getId());

        return ParticipantDto.builder()
                .id(participantEntity.getId())
                .firstName(personalData.getFirstName())
                .lastName(personalData.getLastName())
                .image(personalData.getImage())
                .build();
    }
    private EventPostDto convertToEventPostDto(EventPostEntity ent) {
            return EventPostDto.builder()
                    .id(ent.getId())
                    .userId(ent.getUserId())
                    .image(ent.getImage())
                    .title(ent.getTitle())
                    .build();
    }

    @Transactional
    public EventDto createEvent(EventCreationDto eventCreationDto) {
        LocalDateTime startDate = eventCreationDto.getStartDate();

        EventEntity eventEntity = new EventEntity();
        if (startDate == null) {
            startDate = LocalDateTime.now();
        }
        eventEntity.setStartDate(eventCreationDto.getStartDate());
        eventEntity.setEndDate(eventCreationDto.getEndDate());
        eventEntity.setTitle(eventCreationDto.getTitle());
        eventEntity.setType(eventCreationDto.getType().getName());
        eventEntity.setDescription(eventCreationDto.getDescription());
        eventEntity.setCoordinates(convertCoordinatesToPoint(eventCreationDto.getCoordinates()));
        eventEntity.setImage(eventCreationDto.getImage());

        EventEntity event = eventRepository.save(eventEntity);
        UserEntity user = userService.getCurrentUserEntity();

        HostEntity host = new HostEntity();
        host.setEvent(event);
        host.setUser(user);
        hostRepository.save(host);

        return convertToEventDto(event);
    }

    private Point convertCoordinatesToPoint(Coordinate coordinate) {
        GeometryFactory factory = new GeometryFactory();
        Coordinate[] coordinates = new Coordinate[] { coordinate };
        CoordinateSequence coordinateSequence = new CoordinateArraySequence(coordinates);

        return new Point(coordinateSequence, factory);
    }

    public List<EventDto> getEventsByType(Type type) {
        return eventRepository.findAllByType(type.getName())
                .stream()
                .map(this::convertToEventDto)
                .collect(Collectors.toList());
    }
    @Transactional
    public EventDto participateInEvent(Long eventId) {

        Optional<EventEntity> optionalEventEntity = eventRepository.findById(eventId);
        if (optionalEventEntity.isEmpty()) {
            throw new EntityNotFoundException("Couldn't find event of id " + eventId);
        }
        EventEntity eventEntity = optionalEventEntity.get();
        UserEntity user = userService.getCurrentUserEntity();

        ParticipantEntity participant = new ParticipantEntity();

        participant.setEvent(eventEntity);
        participant.setUser(user);
        participantRepository.save(participant);

        return convertToEventDto(eventEntity);
    }

    public EventDto getHostedEvents() {
        var currentUserId = userService.getCurrentUserId();
        var optionalHost = hostRepository.findByUserId(currentUserId);
        if (optionalHost.isEmpty() || optionalHost.get().getEvent() == null) {
            throw new EntityNotFoundException("You're not hosting any events");
        }
        HostEntity host = optionalHost.get();
        EventEntity eventEntity = host.getEvent();

        return convertToEventDto(eventEntity);
    }

    public List<EventDto> getAllEvents() {
        return eventRepository.findAll().stream()
                .map(this::convertToEventDto)
                .collect(Collectors.toList());
    }
}
