import { useEffect, useState } from "react";
import Form from "./Form";
import Input from "./Input";
import Button from "./Button";
import useApi from "../../hooks/use-api";
import { setToken } from "../../utils/auth";
import { useNavigate } from "react-router-dom";

interface Props {
  onSuccess: () => void;
}

const LoginForm = ({ onSuccess }: Props) => {
  const navigate = useNavigate();
  const { data, response, loading, error, fetch } = useApi("/login", {
    method: "POST",
  });

  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");

  const validEmail = username.length > 0;
  const validPassword = password.length >= 6;

  const formValid = validEmail && validPassword && !loading;

  const onSignUpHandler = () => {
    navigate("/register");
  };

  const onSubmitHandler = () => {
    if (!formValid) return;
    fetch({
      username,
      password,
    });
  };

  useEffect(() => {
    if (response?.ok) {
      const auth = response.headers.get("Authorization");

      const token = auth?.split(" ")[1];
      
      if (auth && token) {
        setToken(token);
        onSuccess();
      } else {
        console.log(token);
      }
    } else {
      console.log("responce", response);
    }
  }, [response, onSuccess]);
  const aStyle = {
    borderColor: 'rgb(212,42,70)',
    color:'rgb(212,42,70)'
  };
  return (
    
    <Form onSubmit={onSubmitHandler}>
      <h1 className="text-lg font-bold text-center p-10">Log in to your account.</h1>
      {error && <h2 className="text-red-600">{error}</h2>}

      <Input
        name="username"
        title="Username"
        type="text"
        placeholder="Username"
        value={username}
        onChange={setUsername}
        isValid={validEmail}
        errorMessage="Please enter a valid username."
      />

      <Input
        name="password"
        title="Password"
        type="password"
        placeholder="Password"
        value={password}
        onChange={setPassword}
        isValid={validPassword}
        errorMessage="Password must be at least 6 characters long."
      />
      <Button text={"Log in"} disabled={!formValid} loading={loading} />

      <p className="text-sm font-light text-gray-500 dark:text-gray-400 text-center ">
        <div className="p-5 text-black font-bold">
        If you don't have account yet{" "}
        </div>
        <a 
        className="cursor-pointer inline-block rounded border-2 text-purple-400 border-purple-400 px-6 pb-[6px] pt-2 text-xs font-medium uppercase leading-normal text-danger transition duration-150 ease-in-out hover:border-danger-600 hover:bg-neutral-500 hover:bg-opacity-10 hover:text-danger-600 focus:border-danger-600 focus:text-danger-600 focus:outline-none focus:ring-0 active:border-danger-700 active:text-danger-700 dark:hover:bg-neutral-100 dark:hover:bg-opacity-10" 
        onClick={onSignUpHandler}>

          Sign up!
        </a>
      </p>
    </Form>
  );
};

export default LoginForm;
