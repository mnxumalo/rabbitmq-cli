## The contents of this file are subject to the Mozilla Public License
## Version 1.1 (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License
## at http://www.mozilla.org/MPL/
##
## Software distributed under the License is distributed on an "AS IS"
## basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
## the License for the specific language governing rights and
## limitations under the License.
##
## The Original Code is RabbitMQ.
##
## The Initial Developer of the Original Code is GoPivotal, Inc.
## Copyright (c) 2007-2016 Pivotal Software, Inc.  All rights reserved.


defmodule RabbitMQ.CLI.Ctl.Commands.ForceResetCommand do
  @behaviour RabbitMQ.CLI.CommandBehaviour
  @flags []

  def merge_defaults(args, opts), do: {args, opts}
  def validate([_|_] = args, _) when length(args) > 0, do: {:validation_failure, :too_many_args}  
  def validate([], _), do: :ok
  def switches(), do: []


  def run([], %{node: node_name}) do
    case :rabbit_misc.rpc_call(node_name, :rabbit_mnesia, :force_reset, []) do
      {:error, reason} ->
        {:reset_failed, {reason, node_name}}
      result -> result 
    end
  end

  def usage, do: "force_reset"

  def flags, do: @flags

  def banner(_, %{node: node_name}), do: "Forcefully resetting node #{node_name} ..."
end