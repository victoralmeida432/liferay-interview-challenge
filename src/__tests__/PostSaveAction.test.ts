import { postSaveAction } from "../controller/PostSaveAction";
import { Request, Response } from "express";
import { DataSource } from "typeorm";
import { Post } from "../entity/Post";
import { Category } from "../entity/Category";

const testDataSource = new DataSource({
  type: "sqlite",
  database: ":memory:",
  synchronize: true,
  entities: [Post, Category],
});

beforeAll(async () => {
  await testDataSource.initialize();
});

afterAll(async () => {
  await testDataSource.destroy();
});

describe("PostSaveAction", () => {
  it("should save a post and return it", async () => {
    const req = {
      body: {
        title: "Test Post",
        text: "Test Content",
      },
    } as Request;

    const res = {
      send: jest.fn(),
    } as unknown as Response;

    const postRepository = testDataSource.getRepository(Post);

    await postSaveAction(req, res, postRepository);

    expect(res.send).toHaveBeenCalledWith(
      expect.objectContaining({
        title: "Test Post",
        text: "Test Content",
      }),
    );
  });
});
