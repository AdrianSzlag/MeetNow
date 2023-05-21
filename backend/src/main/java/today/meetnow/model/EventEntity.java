package today.meetnow.model;


import javax.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;


@Table(name = "event")
@Entity
@Getter
@Setter
public class EventEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title")
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "type")
    private String type;

    @Column(name = "image")
    private String image;

    @Column(name = "coordinates")
    private Point coordinates;

    @Column(name = "start_date")
    private LocalDateTime startDate;

    @Column(name = "end_date")
    private LocalDateTime endDate;
}
