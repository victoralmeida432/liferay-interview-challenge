import "reflect-metadata";
import { DataSource } from "typeorm";
import express, { Express, Request, Response, NextFunction } from "express";
import * as bodyParser from "body-parser";
import { AppRoutes } from "./routes";
import { Post } from "./entity/Post";
import { Category } from "./entity/Category";

const app: Express = express();
app.use(bodyParser.json());

// Verifique se estamos no ambiente de testes
const dataSource =
  process.env.NODE_ENV === "test"
    ? new DataSource({
        type: "sqlite",
        database: ":memory:",
        synchronize: true,
        entities: [Post, Category],
      })
    : /* Configuração padrão do MySQL */
      new DataSource({
        type: "mysql",
        host: process.env.TYPEORM_HOST,
        port: Number(process.env.TYPEORM_PORT),
        username: process.env.TYPEORM_USERNAME,
        password: process.env.TYPEORM_PASSWORD,
        database: process.env.TYPEORM_DATABASE,
        entities: [Post, Category],
        synchronize: true,
      });

dataSource
  .initialize()
  .then(() => {
    const postRepository = dataSource.getRepository(Post);

    AppRoutes.forEach((route) => {
      const method = route.method as keyof Express;
      (app[method] as Function)(
        route.path,
        async (request: Request, response: Response, next: NextFunction) => {
          try {
            await route.action(request, response, postRepository);
            next();
          } catch (err) {
            console.error("Error during request processing:", err);
            response.status(500).send({ error: "Internal Server Error" });
          }
        },
      );
    });

    // Inicia o servidor apenas se não estiver em ambiente de teste
    if (process.env.NODE_ENV !== "test") {
      app.listen(3000);
      console.log("Express application is up and running on port 3000");
    }
  })
  .catch((error) => console.log("TypeORM connection error: ", error));

export default app; // Exporta a aplicação para uso nos testes
