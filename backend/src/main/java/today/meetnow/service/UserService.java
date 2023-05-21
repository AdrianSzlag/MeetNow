package today.meetnow.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import today.meetnow.model.UserEntity;
import today.meetnow.model.UserPersonalDataEntity;
import today.meetnow.repository.UserPersonalDataRepository;
import today.meetnow.repository.UserRepository;

import javax.persistence.EntityNotFoundException;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final UserPersonalDataRepository userPersonalDataRepository;

    public UserPersonalDataEntity getUserPersonalData(Long userId) {
        return userPersonalDataRepository.findByUserId(userId).orElseThrow(EntityNotFoundException::new);
    }
    public String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Object principal = authentication.getPrincipal();
        String username = null;
        if (principal instanceof UserDetails) {
            username = ((UserDetails) principal).getUsername();
        } else if (principal instanceof String) {
            username = (String) principal;
        }
        return username;
    }
    public Long getCurrentUserId() {
        var authenticatedUserName = getCurrentUsername();
        UserEntity userEntity = userRepository.findByUsername(authenticatedUserName).orElseThrow(IllegalStateException::new);
        return userEntity.getId();
    }
    public UserEntity getCurrentUserEntity() {
        return userRepository.findById(getCurrentUserId()).get();
    }
}
