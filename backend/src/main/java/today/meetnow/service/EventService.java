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
import today.meetnow.repository.*;

import java.time.LocalDateTime;
import java.util.List;
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
        var hostDto = convertToHostDto(hostRepository.findByEventId(eventEntity.getId()).get());

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
}
