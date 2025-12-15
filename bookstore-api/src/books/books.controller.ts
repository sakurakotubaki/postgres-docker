import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { BooksService } from './books.service';
import { CreateBookDto } from './dto/create-book.dto';
import { UpdateBookDto } from './dto/update-book.dto';

@Controller('books')
export class BooksController {
  constructor(private readonly booksService: BooksService) {}

  @Post()
  create(@Body() createBookDto: CreateBookDto) {
    return this.booksService.create(createBookDto);
  }

  @Get()
  findAll() {
    return this.booksService.findAll();
  }

  @Get(':title')
  findOne(@Param('title') title: string) {
    return this.booksService.findOne(title);
  }

  @Patch(':title')
  update(@Param('title') title: string, @Body() updateBookDto: UpdateBookDto) {
    return this.booksService.update(title, updateBookDto);
  }

  @Delete(':title')
  remove(@Param('title') title: string) {
    return this.booksService.remove(title);
  }
}
