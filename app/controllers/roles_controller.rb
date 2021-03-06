# -*- coding: utf-8 -*-

class RolesController < ApplicationController

  before_action { add_body_class('edit') }
  before_action { sub_layout("admin") if admin? }
  before_action :require_admin

  def index
    @roles = Role.order(:category, :name)
  end

  def new
    @role = Role.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(params[:role])

    if @role.save
      redirect_to roles_url, notice: "Rollen skapades"
    else
      render action: "new"
    end
  end

  def update
    @role = Role.find(params[:id])

    if @role.update_attributes(params[:role])
      redirect_to roles_url, notice: "Rollen uppdaterades"
    else
      render action: "edit"
    end
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    redirect_to roles_url, notice: "Rollen togs bort"
  end
end
