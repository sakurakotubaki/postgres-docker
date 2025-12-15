import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateBookDto } from './dto/create-book.dto';
import { UpdateBookDto } from './dto/update-book.dto';

@Injectable()
export class BooksService {
  constructor(private prisma: PrismaService) {}

  create(createBookDto: CreateBookDto) {
    return this.prisma.book.create({
      data: createBookDto,
    });
  }

  findAll() {
    return this.prisma.book.findMany({
      include: { publisher: true },
    });
  }

  findOne(title: string) {
    return this.prisma.book.findUnique({
      where: { book_title: title },
      include: { publisher: true },
    });
  }

  update(title: string, updateBookDto: UpdateBookDto) {
    return this.prisma.book.update({
      where: { book_title: title },
      data: updateBookDto,
    });
  }

  remove(title: string) {
    return this.prisma.book.delete({
      where: { book_title: title },
    });
  }
}
