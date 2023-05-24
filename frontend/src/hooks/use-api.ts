import { useState } from "react";
import fetchApi from "../utils/fetchApi";

const useApi = <T>(path: string, options?: RequestInit) => {
  const [data, setData] = useState<T>();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | undefined>(undefined);
  const [res, setRes] = useState<Response | undefined>(undefined);

  const fetch = async (data?: Object) => {
    setLoading(true);
    setError(undefined);
    setData(undefined);

    let currentOptions = (options ? { ...options } : {}) as RequestInit;
    if (data) currentOptions.body = JSON.stringify(data);

    let response;
    try {
      response = await fetchApi(path, currentOptions);
      setRes(response);
    } catch (e) {
      setError("Something went wrong with fetching!");
      setLoading(false);
      return;
    }

    if (response.headers.get("Content-Type") === "application/json") {
      let json = {} as T;
      try {
        json = (await response.json()) as T;
        if (response.ok) {
          setData(json);
        } else {
          const error = json as { message?: string };
          setError(
            error.message
              ? error.message
              : `Something went wrong! ${response.status}`
          );
        }
      } catch (e) {
        setError("Something went wrong with parsing json!");
      }
    } else {
      if (!response.ok) {
        try {
          json = (await response.json()) as { message: string };
          console.log(json);
          if (json.message) {
            setError(`${json.message}`);
          }
          else {
            throw new Error('Could not read error message!');
          }
        }
        catch (e){

          setError(`Could not read error message (${response.status})`);
        }
      }
    }
    setLoading(false);
  };

  return { data, loading, response: res, error, fetch };
};

export default useApi;
