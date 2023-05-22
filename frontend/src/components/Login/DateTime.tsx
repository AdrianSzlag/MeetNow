import { useState, useEffect } from "react";

interface Props {
  name: string;
  title: string;
  value: string;
  onChange: (value: string) => void;
  isValid: boolean;
  errorMessage: string;
}

const DateTime = ({
  name,
  title,
  value,
  onChange,
  isValid,
  errorMessage,
}: Props) => {
  const [isTouched, setIsTouched] = useState(false);
  const [error, setError] = useState(false);

  const onChangeHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
    onChange(event.target.value);
    setError(false);
  };

  const onBlurHandler = () => {
    setIsTouched(true);
  };

  useEffect(() => {
    if (isTouched) {
      const timeout = setTimeout(() => {
        if (!isValid) {
          setError(true);
        }
      }, 1000);
      return () => {
        clearTimeout(timeout);
      };
    }
  }, [isTouched, isValid, value]);

  return (
    <div className="flex flex-col justify-center items-center">
      <label htmlFor={name} className="">
        {title}
      </label>
      <input
        type="datetime-local"
        value={value}
        onChange={onChangeHandler}
        onBlur={onBlurHandler}
        name={name}
        className={`${
          error ? "border-red-300" : "border-violet-900"
        } block border rounded-full`}
      />
      <p className={`text-xs text-red-500 ${error ? "" : "invisible"}`}>
        {errorMessage}
      </p>
    </div>
  );
};

export default DateTime;