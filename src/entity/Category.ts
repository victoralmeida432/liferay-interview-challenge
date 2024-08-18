import { Entity, PrimaryGeneratedColumn, Column } from "typeorm";

@Entity()
export class Category {
  @PrimaryGeneratedColumn()
  id: number = 0; // Inicializar com valor padrão

  @Column()
  name: string = ""; // Inicializar com valor padrão
}
