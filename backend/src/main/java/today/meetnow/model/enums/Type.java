package today.meetnow.model.enums;

import lombok.Getter;

@Getter
public enum Type {
    PARTY("Party"),
    SPORT("Sport"),
    EVENT("Event");

    private String name;
    Type(String name) {
        this.name = name;
    }
}
