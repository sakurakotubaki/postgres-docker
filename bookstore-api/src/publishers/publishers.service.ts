import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreatePublisherDto } from './dto/create-publisher.dto';
import { UpdatePublisherDto } from './dto/update-publisher.dto';

@Injectable()
export class PublishersService {
  constructor(private prisma: PrismaService) {}

  create(createPublisherDto: CreatePublisherDto) {
    return this.prisma.publisher.create({
      data: createPublisherDto,
    });
  }

  findAll() {
    return this.prisma.publisher.findMany({
      include: { books: true },
    });
  }

  findOne(id: number) {
    return this.prisma.publisher.findUnique({
      where: { publisher_id: id },
      include: { books: true },
    });
  }

  update(id: number, updatePublisherDto: UpdatePublisherDto) {
    return this.prisma.publisher.update({
      where: { publisher_id: id },
      data: updatePublisherDto,
    });
  }

  remove(id: number) {
    return this.prisma.publisher.delete({
      where: { publisher_id: id },
    });
  }
}
