package today.meetnow.model.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.locationtech.jts.geom.Coordinate;
import today.meetnow.model.enums.Type;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
public class EventCreationDto {
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    @NotNull
    @NotBlank
    private String title;
    private String description;
    @NotNull
    private Type type;
    @NotNull
    @NotBlank
    private String image;
    @NotNull
    private Coordinate coordinates;
}