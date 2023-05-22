import { useEffect, useState } from "react";
import Events from "../components/Events/Events";
import MyMap from "../components/Map/Map";
import Memories from "../components/Memories/Memories";
import SideMenu from "../components/SideMenu/SideMenu";
import { EventsDataProvider } from "../hooks/EventsDataProvider";
import { EventsFocusProvider } from "../hooks/EventsFocusProvider";
import { useNavigate } from "react-router-dom";
import { getToken } from "../utils/auth";
import EventForm from "../components/Events/EventForm";

const Main = () => {
  const navigate = useNavigate();
  const [createEventPopupOpen, setCreateEventPopupOpen] = useState(false);
  const [appState, setAppState] = useState<"main" | "memories">("main");

  useEffect(() => {
    const token = getToken();
    if (!token) {
      navigate("/login", { replace: true });
    }
  }, []);

  const onChangeAppStateHandler = (state: "main" | "memories") => {
    setAppState(state);
  };

  return (
    <div className="z-5 flex w-screen flex-col">
      <EventsDataProvider>
        <EventsFocusProvider>
          <MyMap />
          /*
          <SideMenu onChangeAppState={onChangeAppStateHandler} />
          {appState === "main" && (
            <Events
              showCreateEventPopup={() => setCreateEventPopupOpen(true)}
            />
          )}
          {appState === "memories" && (
            <Memories
              showCreateEventPopup={() => setCreateEventPopupOpen(true)}
            />
          )}
          {createEventPopupOpen && (
            <div className="fixed inset-0 flex items-center justify-center z-50">
              <div className="bg-white w-96 p-6 rounded-lg">
              <button
                  className="relative top-0 left-0 p-2 text-black"
                  onClick={() => setCreateEventPopupOpen(false)}
                >X
                  </button>
                <EventForm onSuccess={() => setCreateEventPopupOpen(false)} />
              </div>
            </div>
          )}
        </EventsFocusProvider>
      </EventsDataProvider>
    </div>
  );
};

export default Main;
