interface User {
  id: number;
  name: string;
}

interface Event {
  id: number;
  title: string;
  description: string;
  participants: Array<User>;
  coordinates: Array<number>;
  type: string;
  image: string;
}

interface EventDTO {
  coordinates: Array<number>;
  description: string;
  endDate: string;
  host: {
    firstName: string;
    lastName: string;
    id: number;
    image: string;
  };
  id: number;
  image: string;
  startDate: string;
  title: string;
  type: "EVENT" | "PARTY" | "SPORT";
}

export type { User, Event, EventDTO };
