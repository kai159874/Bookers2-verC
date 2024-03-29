class GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      group_user = current_user.group_users.new(group_id: @group.id)
      group_user.save
      redirect_to groups_path, notice: "You have created group successfully."
    else
      render :new
    end
  end

  def index
    @groups = Group.all
    @book = Book.new
  end

  def show
    @group = Group.find(params[:id])
    @book = Book.new
  end

  def edit
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "You have updated group successfully."
    else
      render :edit
    end
  end

  def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    EventMailer.send_mail(@mail_title, @mail_content, group_users).deliver
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image).merge(owner_id: current_user.id)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path(@group)
    end
  end


end
