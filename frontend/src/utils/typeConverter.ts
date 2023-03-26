import { Event, MapBoxEvent } from "../types/types";

const eventToMapBoxEvent = (event: Event): MapBoxEvent => {
  const { id, title, description, coordinates } = event;
  return {
    type: "Feature",
    properties: {
      id,
      title,
      description,
    },
    geometry: {
      coordinates,
      type: "Point",
    },
  };
};

export default eventToMapBoxEvent;