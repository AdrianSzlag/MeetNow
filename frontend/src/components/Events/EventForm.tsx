import { useEffect, useState } from "react";
import Form from "../Login/Form";
import Input from "../Login/Input";
import Button from "../Login/Button";
import useApi from "../../hooks/use-api";
import DateTime from "../Login/DateTime";
import { setToken } from "../../utils/auth";
import { useNavigate } from "react-router-dom";
import EventTypeSelect from "../Login/EventTypeSelect";

enum Type {
  PARTY = "Party",
  SPORT = "Sport",
  EVENT = "Event",
}

interface EventCreationDto {
  startDate: string | null;
  endDate: string | null;
  title: string;
  description: string;
  type: Type | null;
  coordinates: string | null;
}

interface Props {
  onSuccess: () => void;
}

const EventForm: React.FC<Props> = ({ onSuccess }) => {
  const navigate = useNavigate();
  const { response, loading, error, fetch } = useApi("/events", {
    method: "POST",
  });

  const [eventData, setEventData] = useState<EventCreationDto>({
    startDate: null,
    endDate: null,
    title: "",
    description: "",
    type: null,
    coordinates: null,
  });

  const { startDate, endDate, title, description, type, coordinates } =
    eventData;

  const validEvent =
    title.length > 0 &&
    type !== null &&
    coordinates !== null &&
    startDate !== null &&
    endDate !== null &&
    endDate > startDate;

  const formValid = validEvent && !loading;

  const onLoginHandler = () => {
    navigate("/login");
  };

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
        isValid={title.length > 0}
        errorMessage="Please enter a valid title."
      />

      <Input
        name="description"
        title="Description"
        type="text"
        placeholder="Description"
        value={description}
        isValid={description.length > 0}
        onChange={(value) => setEventData({ ...eventData, description: value })}
        errorMessage="Please enter a valid description."
      />

      <DateTime
        name="startDate"
        title="Start Date"
        value={startDate || ""}
        onChange={(value) => setEventData({ ...eventData, startDate: value || null })}
        isValid={startDate !== null}
        errorMessage="Please enter a valid start date."
      />

      <DateTime
        name="endDate"
        title="End Date"
        value={endDate || ""}
        onChange={(value) => setEventData({ ...eventData, endDate: value || null })}
        isValid={endDate !== null && startDate !== null && endDate > startDate}
        errorMessage="Please enter a valid end date."
      />

      <EventTypeSelect onChange={handleEventTypeChange} />

      <Input
        name="coordinates"
        title="Coordinates"
        type="text"
        placeholder="Coordinates"
        value={coordinates || ""}
        onChange={(value) => setEventData({ ...eventData, coordinates: value || null })}
        isValid={coordinates !== null}
        errorMessage="Please enter valid event coordinates."
      />

      <Button text={"Add Event"} disabled={!formValid} loading={loading} />
    </Form>
  );
};

export default EventForm;
