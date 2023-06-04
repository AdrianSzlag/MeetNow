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
    private final UserService userService;
    public List<EventDto> getParticipatedEvents() {
        var currentUserId = userService.getCurrentUserId();

        return eventRepository.findAllByUserId(currentUserId)
                .stream()
                .map(this::convertToEventDto)
                .collect(Collectors.toList());
    }
    public EventShortDto convertToEventShortDto(EventEntity eventEntity) {
        Long eventId = eventEntity.getId();
        var optionalHostEntity = hostRepository.findByEventId(eventId);
        if (optionalHostEntity.isEmpty()) {
            throw new IllegalStateException("No host of event with id " + eventId);
        }
        var hostEntity = optionalHostEntity.get();
        var hostDto = convertToHostDto(hostEntity);

        return EventShortDto.builder()
                .id(eventEntity.getId())
                .startDate(eventEntity.getStartDate())
                .endDate(eventEntity.getEndDate())
                .title(eventEntity.getTitle())
                .description(eventEntity.getDescription())
                .type(eventEntity.getType())
                .image(eventEntity.getImage())
                .host(hostDto)
                .coordinates(convertPointToCoordinates(eventEntity.getCoordinates()))
                .build();
    }
    private EventDto convertToEventDto(EventEntity eventEntity) {
        Long eventId = eventEntity.getId();
        var optionalHostEntity = hostRepository.findByEventId(eventId);
        if (optionalHostEntity.isEmpty()) {
            throw new IllegalStateException("No host of event with id " + eventId);
        }
        var hostEntity = optionalHostEntity.get();
        var hostDto = convertToHostDto(hostEntity);

        List<ParticipantShortDto> participantShortDtoList = participantRepository.findAllByEventId(eventEntity.getId())
                .stream()
                .map(this::convertToParticipantShortDto)
                .collect(Collectors.toList());

        return EventDto.builder()
                .id(eventEntity.getId())
                .startDate(eventEntity.getStartDate())
                .endDate(eventEntity.getEndDate())
                .title(eventEntity.getTitle())
                .description(eventEntity.getDescription())
                .type(eventEntity.getType())
                .image(eventEntity.getImage())
                .coordinates(convertPointToCoordinates(eventEntity.getCoordinates()))
                .participants(participantShortDtoList)
                .host(hostDto)
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
    private ParticipantShortDto convertToParticipantShortDto(ParticipantEntity participantEntity) {
        var personalData = userService.getUserPersonalData(participantEntity.getUser().getId());

        return ParticipantShortDto.builder()
                .id(participantEntity.getId())
                .fullName(personalData.getFirstName() + " " + personalData.getLastName())
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
        if (hostRepository.existsByUserId(user.getId())) {
            throw new IllegalStateException("You cannot host two events at once!");
        }
        hostRepository.save(host);

        return convertToEventDto(event);
    }

    private Point convertCoordinatesToPoint(Double[] coordinates) {
        GeometryFactory factory = new GeometryFactory();
        Coordinate coordinate = new Coordinate(coordinates[0], coordinates[1]);
        Coordinate[] coordinateArray = new Coordinate[] { coordinate };
        CoordinateSequence coordinateSequence = new CoordinateArraySequence(coordinateArray);

        return new Point(coordinateSequence, factory);
    }
    private Double[] convertPointToCoordinates(Point point) {
        Double[] coordinates = new Double[2];
        coordinates[0] = point.getX();
        coordinates[1] = point.getY();
        return coordinates;
    }


    public List<EventShortDto> getEventsByType(Type type) {
        return eventRepository.findAllByType(type.getName())
                .stream()
                .map(this::convertToEventShortDto)
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

    public List<EventShortDto> getAllEvents() {
        return eventRepository.findAll().stream()
                .map(this::convertToEventShortDto)
                .collect(Collectors.toList());
    }

    public EventDto getEvent(Long eventId) {
        Optional<EventEntity> optionalEventEntity = eventRepository.findById(eventId);
        if (optionalEventEntity.isEmpty()) {
            throw new IllegalArgumentException("No event of id " + eventId);
        }
        EventEntity eventEntity = optionalEventEntity.get();
        return convertToEventDto(eventEntity);
    }

    public List<EventShortDto> getEventsBySearchFilters(SearchFiltersDto searchFiltersDto) {
        if (searchFiltersDto.getType() == null && (searchFiltersDto.getTitle() == null || searchFiltersDto.getTitle().isBlank())) {
            return getAllEvents();
        }
        if (searchFiltersDto.getTitle() == null || searchFiltersDto.getTitle().toString().isBlank()) {
            return getEventsByType(searchFiltersDto.getType());
        }
        if (searchFiltersDto.getType() == null || searchFiltersDto.getType().toString().isBlank()) {
            return getEventsByTitle(searchFiltersDto.getTitle());
        }
        return getEventsByTypeAndTitle(searchFiltersDto.getType(), searchFiltersDto.getTitle());
    }

    private List<EventShortDto> getEventsByTypeAndTitle(Type type, String title) {
        return this.eventRepository.findAllByTypeAndTitle(type.getName(), title).stream()
                .map(this::convertToEventShortDto)
                .collect(Collectors.toList());
    }

    private List<EventShortDto> getEventsByTitle(String title) {
        return this.eventRepository.findAllByTitle(title).stream()
                .map(this::convertToEventShortDto)
                .collect(Collectors.toList());
    }
}
