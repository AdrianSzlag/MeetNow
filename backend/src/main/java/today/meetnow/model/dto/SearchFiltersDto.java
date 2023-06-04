package today.meetnow.model.dto;

import lombok.Getter;
import lombok.Setter;
import today.meetnow.model.enums.Type;

@Getter
@Setter
public class SearchFiltersDto {
    private String title;
    private Type type;
}
