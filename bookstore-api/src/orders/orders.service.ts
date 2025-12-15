import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';

@Injectable()
export class OrdersService {
  constructor(private prisma: PrismaService) {}

  create(createOrderDto: CreateOrderDto) {
    return this.prisma.order.create({
      data: createOrderDto,
    });
  }

  findAll() {
    return this.prisma.order.findMany({
      include: {
        orderDetails: {
          include: {
            book: {
              include: { publisher: true },
            },
          },
        },
      },
    });
  }

  findOne(id: string) {
    return this.prisma.order.findUnique({
      where: { order_id: id },
      include: {
        orderDetails: {
          include: {
            book: {
              include: { publisher: true },
            },
          },
        },
      },
    });
  }

  update(id: string, updateOrderDto: UpdateOrderDto) {
    return this.prisma.order.update({
      where: { order_id: id },
      data: updateOrderDto,
    });
  }

  remove(id: string) {
    return this.prisma.order.delete({
      where: { order_id: id },
    });
  }
}
