package today.meetnow.utils;


import org.apache.catalina.User;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import today.meetnow.model.EventEntity;
import today.meetnow.model.HostEntity;
import today.meetnow.model.UserEntity;
import today.meetnow.model.UserPersonalDataEntity;
import today.meetnow.model.dto.EventCreationDto;
import today.meetnow.model.dto.HostDto;
import today.meetnow.model.enums.Type;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;

@Component
public class TestDataProvider {
    private static final LocalDateTime START_DATE = LocalDateTime.now();
    private static final LocalDateTime END_DATE = LocalDateTime.now().plusDays(2);
    private static final String TITLE = "My little pony";
    private static final String DESCRIPTION = "whatever";
    private static final Type TYPE = Type.SPORT;
    private static final String IMAGE_URL = "http://wrzutka.pl/zdjecie2136";
    private static final Coordinate COORDINATES = new Coordinate(21.36, 21.38);
    private static final Double[] doubleCoordinates = new Double[]{41.41, 41.42};
    private static final GeometryFactory GEOMETRY_FACTORY = new GeometryFactory();
    public static final Long ID = Long.valueOf(-2136);


    public static EventCreationDto getEventCreationData() {
        return EventCreationDto.builder()
                .startDate(START_DATE)
                .endDate(END_DATE)
                .title(TITLE)
                .description(DESCRIPTION)
                .type(TYPE)
                .image(IMAGE_URL)
                .coordinates(doubleCoordinates)
                .build();
    }

    public UserEntity getUserEntityData() {
        var userEntity = new UserEntity();
        userEntity.setId(TestDataProvider.ID);
        userEntity.setUsername("testUser");
        userEntity.setPassword("testPassword");
        userEntity.setEmail("testEntityEmail@test.com");

        return userEntity;
    }

    public HostEntity getHostEntityData() {
        var hostEntity = new HostEntity();
        hostEntity.setId(TestDataProvider.ID);
        hostEntity.setUser(this.getUserEntityData());
        hostEntity.setEvent(getEventEntityData());
        return hostEntity;
    }

    public static EventEntity getEventEntityData() {
        EventEntity eventEntity = new EventEntity();
        eventEntity.setId(TestDataProvider.ID);
        eventEntity.setTitle(TITLE);
        eventEntity.setDescription(DESCRIPTION);
        eventEntity.setType(TYPE.getName());
        eventEntity.setImage(IMAGE_URL);
        eventEntity.setStartDate(START_DATE);
        eventEntity.setEndDate(END_DATE);
        eventEntity.setCoordinates(GEOMETRY_FACTORY.createPoint(COORDINATES));
        return eventEntity;
    }

    public UserPersonalDataEntity getUserPersonalDataEntityData() {
        var userPersonalDataEntity = new UserPersonalDataEntity();
        userPersonalDataEntity.setUser(getUserEntityData());
        userPersonalDataEntity.setId(TestDataProvider.ID);
        userPersonalDataEntity.setFirstName("John");
        userPersonalDataEntity.setLastName("Tost");
        userPersonalDataEntity.setImage("http://example.com/User_image.jpg");
        userPersonalDataEntity.setPhoneNr("797855676");
        userPersonalDataEntity.setDateOfBirth(LocalDate.now().minusYears(17));

        return userPersonalDataEntity;
    }
    public static HostDto getHostDtoData(HostEntity hostEntity, UserPersonalDataEntity userPersonalDataEntity) {
        return HostDto.builder()
                .id(hostEntity.getId())
                .firstName(userPersonalDataEntity.getFirstName())
                .lastName(userPersonalDataEntity.getLastName())
                .image(userPersonalDataEntity.getImage())
                .build();
    }
}
