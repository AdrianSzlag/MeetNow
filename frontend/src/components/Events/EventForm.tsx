import { useEffect, useState } from "react";
import Form from "../Login/Form";
import Input from "../Login/Input";
import Button from "../Login/Button";
import useApi from "../../hooks/use-api";
import DateTime from "../Login/DateTime";
import { setToken } from "../../utils/auth";
import { useNavigate } from "react-router-dom";
import EventTypeSelect from "../Login/EventTypeSelect";
import CoordinatesInput from "../Login/CoordinatesInput";

enum Type {
  PARTY = "PARTY",
  SPORT = "SPORT",
  EVENT = "EVENT",
}

interface EventCreationDto {
  startDate: string | null;
  endDate: string | null;
  title: string;
  description: string;
  type: Type | null;
  coordinates: [number, number];
}

interface Props {
  onSuccess: () => void;
}

const EventForm: React.FC<Props> = ({ onSuccess }) => {
  const navigate = useNavigate();
  const { response, loading, error, fetch } = useApi("/api/events/create", {
    method: "POST",
  });

  const [eventData, setEventData] = useState<EventCreationDto>({
    startDate: null,
    endDate: null,
    title: "",
    description: "",
    type: null,
    coordinates: [0, 0],
  });

  const { startDate, endDate, title, description, type, coordinates } =
    eventData;

  const titleValid = title.length > 0;
  const descValid = description.length > 0;
  const startValid = startDate !== null;
  const endValid = endDate !== null && startDate !== null && endDate > startDate;

  const validEvent = titleValid && descValid && startValid && endValid;
  
  const formValid = validEvent && !loading;

  const onSubmitHandler = () => {
   
    if (!formValid) return;
    fetch(eventData);
  };

  useEffect(() => {
    if (response?.ok) {
      // Handle success response
      onSuccess();
    } else {
      // Handle error response
      console.log(response);
    }
  }, [response, onSuccess]);

  const handleEventTypeChange = (selectedType: Type | null) => {
    setEventData({ ...eventData, type: selectedType });
  };

  const [formCoordinates, setFormCoordinates] = useState<[number, number] | null>(null);

  const handleCoordinateChange = (newCoordinates: [number, number]) => {
    setFormCoordinates(newCoordinates);
    setEventData({ ...eventData, coordinates: [newCoordinates[1], newCoordinates[0]] });
  };
  return (
    <Form onSubmit={onSubmitHandler}>
      <h1 className="text-lg font-bold text-center p-2">Add an Event</h1>
      {error && <h2 className="text-red-600">{error}</h2>}

      <Input
        name="title"
        title="Title"
        type="text"
        placeholder="Title"
        value={title}
        onChange={(value) => setEventData({ ...eventData, title: value })}
        isValid={titleValid}
        errorMessage="Please enter a valid title."
      />

      <Input
        name="description"
        title="Description"
        type="text"
        placeholder="Description"
        value={description}
        isValid={descValid}
        onChange={(value) => setEventData({ ...eventData, description: value })}
        errorMessage="Please enter a valid description."
      />

      <DateTime
        name="startDate"
        title="Start Date"
        value={startDate || ""}
        onChange={(value) => setEventData({ ...eventData, startDate: value || null })}
        isValid={startValid}
        errorMessage="Please enter a valid start date."
      />

      <DateTime
        name="endDate"
        title="End Date"
        value={endDate || ""}
        onChange={(value) => setEventData({ ...eventData, endDate: value || null })}
        isValid={endValid}
        errorMessage="Please enter a valid end date."
      />

      <EventTypeSelect onChange={handleEventTypeChange} />

      <CoordinatesInput onCoordinateChange={handleCoordinateChange} />
      <Button text={"Add Event"} disabled={!formValid} loading={loading} />
    </Form>
  );
};

export default EventForm;
