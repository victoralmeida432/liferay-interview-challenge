import { postGetAllAction } from "../controller/PostGetAllAction";
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

describe("PostGetAllAction", () => {
  it("should return all posts", async () => {
    const req = {} as Request;
    const res = { send: jest.fn() } as unknown as Response;
    const mockPosts = [
      {
        id: 1,
        title: "Test Post",
        text: "Test Content",
        categories: [],
      },
    ];
    const postRepository = testDataSource.getRepository(Post);
    jest.spyOn(postRepository, "find").mockResolvedValue(mockPosts);

    await postGetAllAction(req, res, postRepository);

    expect(res.send).toHaveBeenCalledWith(mockPosts);
  });
});
