import { useState } from "react";

enum Type {
  PARTY = "PARTY",
  SPORT = "SPORT",
  EVENT = "EVENT",
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

  const myStyle = {
    background: 'linear-gradient(to right, #ee7724, #d8363a, #dd3675, #b44593)'
  };

  return (
    <div className="flex flex-col justify-center items-center m-4">
      <label htmlFor="eventType">Event Type:</label>
      <select
        name="eventType"
        id="eventType"
        value={selectedType || ""}
        onChange={handleTypeChange}
        className=" h-10 text-white border-0 cursor-pointer rounded-full drop-shadow-md text-center bg-white w-72"
        style={myStyle}
      >
        <option value="">Select an event type</option>
        {Object.values(Type).map((type) => (
          <option key={type} value={type} className="bg-violet-500">
            {type}
          </option>
        ))}
      </select>
    </div>
  );
};

export default EventTypeSelect;
