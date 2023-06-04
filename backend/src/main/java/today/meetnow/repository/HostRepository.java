package today.meetnow.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import today.meetnow.model.HostEntity;

import java.util.Optional;

@Repository
public interface HostRepository extends JpaRepository<HostEntity, Long> {
    Optional<HostEntity> findByUserId(Long userId);
    Optional<HostEntity> findByEventId(Long eventId);
    boolean existsByUserId(Long id);
}
