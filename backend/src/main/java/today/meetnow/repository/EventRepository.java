package today.meetnow.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import today.meetnow.model.EventEntity;
import today.meetnow.model.enums.Type;

import java.util.List;

@Repository
public interface EventRepository extends JpaRepository<EventEntity, Long> {
    List<EventEntity> findAllByTitle(String title);
    List<EventEntity> findAllByType(String type);
    List<EventEntity> findAllByTypeAndTitle(Type type, String title);
    @Query("SELECT e FROM EventEntity e, ParticipantEntity p, UserEntity u WHERE p.event = e AND p.user = u AND u.id = :userId")
    List<EventEntity> findAllByUserId(Long userId);

}
