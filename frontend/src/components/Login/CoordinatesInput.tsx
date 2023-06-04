import React, { useState } from "react";
import { Map, Marker } from "pigeon-maps";

interface CoordinatesInputProps {
  onCoordinateChange: (coordinates: [number, number]) => void;
}

const CoordinatesInput: React.FC<CoordinatesInputProps> = ({
  onCoordinateChange,
}) => {
  const [coordinates, setCoordinates] = useState<[number, number] | null>(null);

  const handleMapClick = (event: any) => {
    const { latLng } = event;
    const latitude = latLng[0];
    const longitude = latLng[1];

    setCoordinates([latitude, longitude]);
    onCoordinateChange([latitude, longitude]);
  };

  const handleClearCoordinates = () => {
    setCoordinates(null);
    onCoordinateChange([0, 0]);
  };

  return (
    <div>
      <div style={{ height: "300px" }}>
        <Map center={[0, 0]} zoom={1} onClick={handleMapClick}>
          {coordinates && (
            <Marker anchor={coordinates} payload={1} />
          )}
        </Map>
      </div>
            <div className="flex flex-col justify-center items-center">
      <input
        type="text"
        placeholder="Coordinates"
        value={coordinates ? coordinates.join(", ") : ""}
        readOnly
        className=" w-full text-center"
      />

     
    </div>
    </div>
  );
};

export default CoordinatesInput;
