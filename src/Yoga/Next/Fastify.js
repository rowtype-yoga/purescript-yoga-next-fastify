import next from "next";

export const createNextAppImpl = (httpServer, hostname, port) => {
  const dev = process.env.NODE_ENV !== "production";
  const app = next({ dev, hostname, port, httpServer });
  return app.prepare().then(() => app);
};

export const nextRequestHandlerImpl = (nextApp) => {
  const handle = nextApp.getRequestHandler();
  return (req) => (res) => () => { handle(req, res); };
};
