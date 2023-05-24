import { getToken } from "./auth";

const apiUrl = "http://localhost:8080";

const fetchApi = async (path: string, options: RequestInit) => {
  if (!options.headers) {
    options.headers = {} as HeadersInit;
  }
  if (path !== "/register" && path !== "/login"){
      options.headers = {
      ...options.headers,
      Authorization: `Bearer ${getToken()}`,
    };
  }
  options.headers = {
    ...options.headers,
    "Content-Type": "application/json",
  };
  
  //options.mode = "no-cors";
  const url = `${apiUrl}${path}`;

  const response = await fetch(url, options);
  return response;
};

export default fetchApi;
