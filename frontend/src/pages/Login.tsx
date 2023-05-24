import { useNavigate } from "react-router-dom";
import LoginForm from "../components/Login/LoginForm";
import MyMap from "../components/Map/LoginMap";
import { useEffect } from "react";
import { getToken, setToken } from "../utils/auth";

const Login = () => {
  const navigate = useNavigate();

  useEffect(() => {
    const token = getToken();
    if (token) {
      navigate("/", { replace: true });
    }
  }, []);

  const onSuccessHandler = () => {
    navigate("/");
  };

  return (

    <div className="flex items-start justify-center sm:justify-start">

      <div className=" z-10  h-screen bg-white sm:shadow-lg">
        <div
          className="g-6 flex h-full text-neutral-800 flex-col justify-center" >
          <div className="w-full">
            <div
              className="block rounded-lg bg-white">
              <div className="g-0 lg:flex lg:flex-wrap">

                <div className="px-4 md:px-0 lg:w-100%">
                  <div className="md:mx-6 md:p-12">
                    <div className="text-center">
                      <img
                        className="mx-auto w-48"
                        src="/public/MeetLogo.png"
                        alt="logo" />
                      <h4 className="mb-12 mt-1 pb-1 text-xl font-semibold">
                        Do you want to Meet Now ?
                      </h4>
                    </div>
                    <LoginForm onSuccess={onSuccessHandler} />

                  </div>
                </div>

              </div>

            </div>
          </div>
        </div>
      </div>
      <div className="hidden sm:block">
        <MyMap />
      </div>
    </div>

  );
};

export default Login;
