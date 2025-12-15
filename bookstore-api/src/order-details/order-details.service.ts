import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOrderDetailDto } from './dto/create-order-detail.dto';
import { UpdateOrderDetailDto } from './dto/update-order-detail.dto';

@Injectable()
export class OrderDetailsService {
  constructor(private prisma: PrismaService) {}

  create(createOrderDetailDto: CreateOrderDetailDto) {
    return this.prisma.orderDetail.create({
      data: createOrderDetailDto,
    });
  }

  findAll() {
    return this.prisma.orderDetail.findMany({
      include: {
        order: true,
        book: {
          include: { publisher: true },
        },
      },
    });
  }

  findOne(orderId: string, bookTitle: string) {
    return this.prisma.orderDetail.findUnique({
      where: {
        order_id_book_title: {
          order_id: orderId,
          book_title: bookTitle,
        },
      },
      include: {
        order: true,
        book: {
          include: { publisher: true },
        },
      },
    });
  }

  update(
    orderId: string,
    bookTitle: string,
    updateOrderDetailDto: UpdateOrderDetailDto,
  ) {
    return this.prisma.orderDetail.update({
      where: {
        order_id_book_title: {
          order_id: orderId,
          book_title: bookTitle,
        },
      },
      data: updateOrderDetailDto,
    });
  }

  remove(orderId: string, bookTitle: string) {
    return this.prisma.orderDetail.delete({
      where: {
        order_id_book_title: {
          order_id: orderId,
          book_title: bookTitle,
        },
      },
    });
  }
}
