package today.meetnow.service;

import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import today.meetnow.model.*;
import today.meetnow.model.dto.EventCreationDto;
import today.meetnow.model.dto.EventDto;
import today.meetnow.model.dto.HostDto;
import today.meetnow.repository.EventPostRepository;
import today.meetnow.repository.EventRepository;
import today.meetnow.repository.HostRepository;
import today.meetnow.repository.ParticipantRepository;
import today.meetnow.utils.TestDataProvider;
import java.util.ArrayList;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;


@ExtendWith(MockitoExtension.class)
public class EventServiceTest {

    @InjectMocks
    private EventService eventService;
    @Mock
    private EventRepository eventRepository;
    @Mock
    private UserService userService;
    @Mock
    private HostRepository hostRepository;
    @Mock
    private ParticipantRepository participantRepository;
    @Mock
    private EventPostRepository eventPostRepository;
    @Captor
    private ArgumentCaptor<EventEntity> eventEntityArgumentCaptor;
    private TestDataProvider testDataProvider;
    private HostEntity hostEntity;
    private UserPersonalDataEntity userPersonalDataEntity;
    private UserEntity userEntity;


    @BeforeEach
    public void setUp() {
        testDataProvider = new TestDataProvider();
        hostEntity = testDataProvider.getHostEntityData();
        userPersonalDataEntity = testDataProvider.getUserPersonalDataEntityData();
        userEntity = testDataProvider.getUserEntityData();

    }

    @Test
    public void testCreateEvent() {
        // Arrange
        EventCreationDto eventCreationDto = testDataProvider.getEventCreationData();
        HostDto expectedHostDto = testDataProvider.getHostDtoData(hostEntity, userPersonalDataEntity);
        setupMocks();

        // Act
        EventDto actualEventDto = eventService.createEvent(eventCreationDto);

        verify(eventRepository).save(eventEntityArgumentCaptor.capture());
        EventEntity capturedEventEntity = eventEntityArgumentCaptor.getValue();

        // Assert
        Assertions.assertThat(capturedEventEntity.getTitle()).isEqualTo(eventCreationDto.getTitle());
        Assertions.assertThat(capturedEventEntity.getDescription()).isEqualTo(eventCreationDto.getDescription());

        Assertions.assertThat(actualEventDto.getTitle()).isEqualTo(eventCreationDto.getTitle());
        Assertions.assertThat(actualEventDto.getDescription()).isEqualTo(eventCreationDto.getDescription());

        Assertions.assertThat(actualEventDto.getHost()).usingRecursiveComparison().isEqualTo(expectedHostDto);
    }

    private void setupMocks() {
        when(userService.getCurrentUserEntity()).thenReturn(userEntity);
        when(eventRepository.save(any(EventEntity.class))).thenAnswer(invocation -> {
            EventEntity entity = invocation.getArgument(0);
            entity.setId(TestDataProvider.ID);
            return entity;
        });
        when(hostRepository.findByEventId(TestDataProvider.ID)).thenReturn(Optional.of(hostEntity));
        when(userService.getUserPersonalData(anyLong())).thenReturn(userPersonalDataEntity);
        when(participantRepository.findAllByEventId(anyLong())).thenReturn(new ArrayList<>());
        when(eventPostRepository.findAllByEventId(anyLong())).thenReturn(new ArrayList<>());
    }

}
