defmodule Nex do
  @type header :: %{
          prg_rom_size: non_neg_integer,
          chr_rom_size: non_neg_integer,
          flag_6: Nex.Flag6.t(),
          flag_7: Nex.Flag7.t(),
          prg_ram_size: non_neg_integer
        }

  def load(path \\ "assets/mario.nes") do
    path
    |> Path.expand()
    |> File.read()
    |> case do
      {:ok, file} -> parse(file)
      {:error, _} -> IO.puts("no file")
    end
  end

  def parse(<<"NES", 0x1A, header::binary-size(12), _rest::binary>>) do
    # 0x1A is EOF
    parse_header(header)
  end

  def parse(_) do
    IO.puts("This doesn't appear to be a valid NES file. It could just be me though…")
  end

  @spec parse_header(binary) :: header
  defp parse_header(
         <<prg_rom_size::unsigned-integer, chr_rom::unsigned-integer, flag_6::size(8),
           flag_7::size(8), prg_ram_size::unsigned-integer, _flag_9::size(8), _flag_10::size(8),
           _rest::size(40)>>
       ) do
    %{
      # 16KB
      prg_rom_size: prg_rom_size * 16384,
      chr_rom_size: chr_rom * 8192,
      flag_6: Nex.Flag6.parse(flag_6),
      flag_7: Nex.Flag7.parse(flag_7),
      prg_ram_size: prg_ram_size * 8192
    }
  end
end

defmodule Nex.Flag6 do
  @type t :: %Nex.Flag6{
          vertical_mirroring: boolean,
          horizontal_mirroring: boolean,
          persistant_storage: boolean,
          trainer?: boolean
        }
  defstruct vertical_mirroring: false,
            horizontal_mirroring: false,
            persistant_storage: false,
            trainer?: false

  @spec parse(integer) :: Nex.Flag6.t()
  def parse(byte) do
    use Bitwise

    %Nex.Flag6{
      trainer?: 4 == (byte &&& 0b0000_0100)
    }
  end
end

defmodule Nex.Flag7 do
  @type t :: %Nex.Flag7{
          vs_unisystem: boolean,
          playchoice_10: boolean,
          nes_2_0_format: boolean,
          mapper_upper_nybble: boolean
        }
  defstruct vs_unisystem: false,
            playchoice_10: false,
            nes_2_0_format: false,
            mapper_upper_nybble: false

  @spec parse(byte) :: Nex.Flag7.t()
  def parse(_byte) do
    %Nex.Flag7{}
  end
end
