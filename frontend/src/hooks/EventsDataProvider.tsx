import React, { useCallback, useEffect, useMemo, useState } from "react";
import { Event, EventDTO } from "../types/types";
import getEvents from "./getEvents";
import fetchApi from "../utils/fetchApi";

interface EventsDataContextType {
  events: Event[];
  typeQuery: string;
  setTypeQuery: (type: string) => void;
  searchQuery: string;
  setSearchQuery: (search: string) => void;
  collection: "events" | "memories";
  setCollection: (collection: "events" | "memories") => void;
  loading: boolean;
}

const EventsDataContext = React.createContext<EventsDataContextType>(
  {} as EventsDataContextType
);

interface Props {
  children: React.ReactNode;
}

const EventsDataProvider = ({ children }: Props) => {
  const [typeQuery, setTypeQuery] = useState<string>("");
  const [searchQuery, setSearchQuery] = useState<string>("");
  const [loading, setLoading] = useState<boolean>(false);
  const [collection, setCollection] = useState<"events" | "memories">("events");
  const [events, setEvents] = useState<Event[]>([]);

  useEffect(() => {
    setLoading(true);
    setEvents([]);

    const typeString = typeQuery === "friendsActivity" ? "PARTY" : typeQuery === "publicEvents" ? "SPORT" : "";
    const searchQueryString = `/api/events/search?type=${typeString}&title=${searchQuery}`;
    fetchApi(searchQueryString, { method: "GET" }).then((res) => {
      if (res.ok) {
        return res.json();
      }
      throw new Error("Error fetching events");
    }).then((eventDTOs: EventDTO[]) => {
      console.log(eventDTOs);
      const events = eventDTOs.map((eventDTO) => {
        const type = eventDTO.type === "PARTY" ? "friendsActivity" : eventDTO.type === "SPORT" ? "publicEvents" : "";
        const event: Event = {
          id: eventDTO.id,
          title: eventDTO.title,
          description: eventDTO.description,
          participants: [],
          coordinates: eventDTO.coordinates,
          type,
          image: eventDTO.image,
        };
        return event;
      });
      const eventsFromFile = getEvents(typeQuery, searchQuery, collection);
      const allEvents = [...events, ...eventsFromFile];
      setEvents(allEvents);
      setLoading(false);
    });
  }, [typeQuery, searchQuery, collection]);



  const value = useMemo(() => {
    const eventsData = {
      events,
      typeQuery,
      setTypeQuery,
      searchQuery,
      setSearchQuery,
      collection,
      setCollection,
      loading,
    } as EventsDataContextType;
    return eventsData;
  }, [typeQuery, searchQuery, collection, loading, events]);

  return (
    <EventsDataContext.Provider value={value}>
      {children}
    </EventsDataContext.Provider>
  );
};

export { EventsDataProvider };
export const useEvents = () => React.useContext(EventsDataContext);
