import "reflect-metadata";
import { createConnection, Connection } from "typeorm";
import { Request, Response } from "express";
import express, { Express } from "express";
import * as bodyParser from "body-parser";
import { AppRoutes } from "./routes";

createConnection()
  .then(async (connection: Connection) => {
    const app: Express = express();
    app.use(bodyParser.json());

    AppRoutes.forEach((route) => {
      const method = route.method as keyof Express;
      (app[method] as Function)(
        route.path,
        (request: Request, response: Response, next: Function) => {
          route
            .action(request, response)
            .then(() => next())
            .catch((err) => next(err));
        },
      );
    });

    // run app
    app.listen(3000);

    console.log("Express application is up and running on port 3000");
  })
  .catch((error) => console.log("TypeORM connection error: ", error));
