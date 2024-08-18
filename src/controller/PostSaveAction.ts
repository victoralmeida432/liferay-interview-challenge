import { Request, Response } from "express";
import { Repository } from "typeorm";
import { Post } from "../entity/Post";

export async function postSaveAction(
  request: Request,
  response: Response,
  postRepository: Repository<Post>,
) {
  const newPost = postRepository.create(request.body);
  await postRepository.save(newPost);
  response.send(newPost);
}
