defmodule Nex.CPU do
  @typedoc """
  [More CPU info](http://wiki.nesdev.com/w/index.php/CPU_registers)
  """
  @type cpu :: %{
          accumulator: integer,
          x_index: integer,
          y_index: integer,
          program_counter: integer,
          stack_pointer: integer,
          status_register: integer
        }
  defstruct accumulator: 0,
            x_index: 0,
            y_index: 0,
            program_counter: 0,
            stack_pointer: 0,
            status_register: 0

  @doc """
  ## Examples

    iex > Nex.CPU.create()
    {0, 0, 0, 0, 0}
  """
  def create(), do: %Nex.CPU{}
end
