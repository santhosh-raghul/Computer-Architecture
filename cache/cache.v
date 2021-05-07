module  cache(
	// address has 16 bits --> 2 bit tag + 10 bit index + 2 bit offset
	input [15:0]read_address,
	input [15:0]write_address,
	input [31:0]write_data,
	input read_en,
	input write_en,
	input clk,
	output reg [31:0]read_data
);

	reg [511:0]main_memory[4095:0]; // 4 times the size of the cache
	reg [511:0]cache[1023:0];
	reg [1:0]tag[1023:0];
	reg [1023:0]valid,dirty;
	reg [11:0]main_memory_block_address;
	reg [9:0]index;
	reg [3:0]offset;

	integer i;
	initial // initialize everything to 0
	begin
		for(i=0;i<1024;i=i+1)
		begin
			cache[i]=512'b0;
			tag[i]=2'b0;
		end
		for(i=0;i<4096;i=i+1)
			main_memory[i]=512'b0;
		valid=1024'b0;
		dirty=1024'b0;
		main_memory_block_address=12'b0;
		index=10'b0;
		offset=4'b0;
		$display("--------------------------------------------------------------------------------------------------");
	end

	always @(posedge clk)
	begin

		index=read_address[13:4];
		offset=read_address[3:0];

		if(read_en)
		begin
			if(read_address[15:14]==tag[index] && valid[index])
			begin
				read_data=cache[index][32*(offset+1)-:32];
				$display("read hit, value at %b_%b_%b is %d",read_address[15:14],read_address[13:4],read_address[3:0],read_data);
			end
			else
			begin
				$display("read miss");
				if(valid[index] && dirty[index])
				begin
					main_memory_block_address={tag[index],index};
					main_memory[main_memory_block_address]=cache[index];
					$display("dirty bit was set, writing back block %b_%b from cache index %b",tag[index],index,index);
				end
				else
					$display("dirty bit not set, no write back needed");
				$display("loading block %b_%b from main memory to cache index %b and setting valid bit to 1",read_address[15:14],index,index);
				main_memory_block_address={read_address[15:14],index};
				cache[index]=main_memory[main_memory_block_address];
				tag[index]=read_address[15:14];
				valid[index]=1'b1;
				read_data=cache[index][32*(offset+1)-:32];
				$display("value at %b_%b_%b is %d",read_address[15:14],read_address[13:4],read_address[3:0],read_data);
			end
		end
		else if(write_en)
		begin
			if(write_address[15:14]==tag[index] && valid[index])
			begin
				cache[index][32*(offset+1)-:32]=write_data;
				dirty[index]=1'b1;
				$display("write hit, value at %b_%b_%b updated to %d, dirty bit set to 1",write_address[15:14],write_address[13:4],write_address[3:0],write_data);
			end
			else
			begin
				$display("write miss");
				if(valid[index] && dirty[index])
				begin
					main_memory_block_address={tag[index],index};
					main_memory[main_memory_block_address]=cache[index];
					$display("dirty bit was set, writing back block %b_%b from cache index %b",tag[index],index,index);
				end
				else
					$display("dirty bit not set, no write back needed");
				$display("loading block %b_%b from main memory to cache index %b",write_address[15:14],index,index);
				main_memory_block_address={read_address[15:14],index};
				cache[index]=main_memory[main_memory_block_address];
				tag[index]=write_address[15:14];
				valid[index]=1'b1;
				cache[index][32*(offset+1)-:32]=write_data;
				dirty[index]=1'b1;
				$display("value at %b_%b_%b updated to %d, dirty bit set to 1",write_address[15:14],write_address[13:4],write_address[3:0],write_data);
			end
		end
		else
		begin
			read_data=32'bz;
			$display("cache inactive");
		end

		$display("--------------------------------------------------------------------------------------------------");

	end

endmodule