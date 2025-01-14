package today.meetnow.config.registration.dto;


import today.meetnow.model.UserEntity;


public record RegistrationResponse(Long id, String username) {
    public static RegistrationResponse ofUserEntity(UserEntity userEntity) {
        return new RegistrationResponse(userEntity.getId(), userEntity.getUsername());
    }
}
