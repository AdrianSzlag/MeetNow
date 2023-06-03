package today.meetnow.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.web.bind.annotation.*;
import today.meetnow.model.dto.EventCreationDto;
import today.meetnow.model.dto.EventDto;
import today.meetnow.model.dto.SearchFiltersDto;
import today.meetnow.model.enums.Type;
import today.meetnow.service.EventService;

import java.util.List;


@RestController
@RequiredArgsConstructor
@CrossOrigin
@RequestMapping("/api/events/")
public class EventController {
    private final EventService eventService;

    @GetMapping("/type")
    public List<EventDto> getEventsByType(Type type) {
        return eventService.getEventsByType(type);
    }
    @PostMapping("/participate/{eventId}")
    public EventDto participateInEvent(@PathVariable Long eventId) {
        return eventService.participateInEvent(eventId);
    }
    @GetMapping
    public List<EventDto> getAllEvents() {
        return eventService.getAllEvents();
    }
    @PostMapping("/create")
    public EventDto createEvent(@RequestBody EventCreationDto eventCreationDto) {
        return eventService.createEvent(eventCreationDto);
    }
    @GetMapping("/participated")
    public List<EventDto> getParticipatedEvents() {
       return eventService.getParticipatedEvents();
    }
    @GetMapping("/hosted")
    public EventDto getHostedEvents() {
        return eventService.getHostedEvents();
    }

}
