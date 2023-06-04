package today.meetnow.model.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ParticipantShortDto {
    private Long id;
    private String fullName;
}
