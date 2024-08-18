import { Request, Response } from "express";
import { getManager, Repository } from "typeorm";
import { Post } from "../entity/Post";

/**
 * Loads all posts from the database.
 */
export async function postGetAllAction(
  request: Request,
  response: Response,
  postRepository: Repository<Post> = getManager().getRepository(Post),
) {
  // load a post by a given post id
  const posts = await postRepository.find();

  // return loaded posts
  response.send(posts);
}
