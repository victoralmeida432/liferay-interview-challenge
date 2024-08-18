import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToMany,
  JoinTable,
} from "typeorm";
import { Category } from "./Category";

@Entity()
export class Post {
  @PrimaryGeneratedColumn()
  id: number = 0;

  @Column()
  title: string = "";

  @Column("text")
  text: string = "";

  @ManyToMany((type) => Category, { cascade: true })
  @JoinTable()
  categories: Category[] = [];
}
