package today.meetnow.model.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;


@Getter
@Setter
@Builder
public class EventDto {
    private Long id;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private String title;
    private String description;
    private String type;
    private String image;
    private Double[] coordinates;
    private HostDto host;
    private List<ParticipantShortDto> participants;
}