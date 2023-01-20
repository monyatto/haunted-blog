# frozen_string_literal: true

class BlogsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  before_action :set_blog, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  def index
    @blogs = Blog.search(params[:term]).published.default_order
  end

  def show; end

  def new
    @blog = Blog.new
  end

  def edit; end

  def create
    @blog = current_user.blogs.new(blog_params)
    if @blog.save
      @blog.update(random_eyecatch: false) if @blog.random_eyecatch && current_user.premium == false
      redirect_to blog_url(@blog), notice: 'Blog was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @blog.update(blog_params)
      @blog.update(random_eyecatch: false) if @blog.random_eyecatch && current_user.premium == false
      redirect_to blog_url(@blog), notice: 'Blog was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    correct_user
    @blog.destroy!

    redirect_to blogs_url, notice: 'Blog was successfully destroyed.', status: :see_other
  end

  private

  def set_blog
    if Blog.find(params[:id]).secret
      if user_signed_in?
        correct_user
      else
        @blog = Blog.where(secret: false).find(params[:id])
      end
    else
      @blog = Blog.find(params[:id])
    end
  end

  def blog_params
    params.require(:blog).permit(:title, :content, :secret, :random_eyecatch)
  end

  def correct_user
    @blog = current_user.blogs.find(params[:id])
  end
end
