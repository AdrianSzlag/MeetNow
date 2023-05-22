import { useState } from "react";

enum Type {
  PARTY = "Party",
  SPORT = "Sport",
  EVENT = "Event",
}

interface EventTypeSelectProps {
  onChange: (selectedType: Type | null) => void;
}

const EventTypeSelect: React.FC<EventTypeSelectProps> = ({ onChange }) => {
  const [selectedType, setSelectedType] = useState<Type | null>(null);

  const handleTypeChange = (event: React.ChangeEvent<HTMLSelectElement>) => {
    const value = event.target.value as Type;
    setSelectedType(value);
    onChange(value);
  };

  return (
    <div className="flex flex-col justify-center items-center">
      <label htmlFor="eventType">Event Type:</label>
      <select
        name="eventType"
        id="eventType"
        value={selectedType || ""}
        onChange={handleTypeChange}
      >
        <option value="">Select an event type</option>
        {Object.values(Type).map((type) => (
          <option key={type} value={type}>
            {type}
          </option>
        ))}
      </select>
    </div>
  );
};

export default EventTypeSelect;
