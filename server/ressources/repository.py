from flask_restful import Resource, reqparse


# We save our data in a python list, for simplicity
repositories = [

    {
        "Index": "XDFT",
        "Title": "Xilinx Discrete Fourier Transform",
        "Version": "001",
        "Description": "Xilinx Discrete Fourier Transform",
        "Changelog": ["25.02.2021 Primary release"],
        "File": "xdft.bin",
        "Date": "25.02.2021",
        "Checksum": "24f25f3fb997ee444fc162108267d6cfd040380af4e2b559c0f50da5b9eb3501f48cd567eb0161f91212624b47c628cfc82305c7a6ad47ee1bfab01a15ae9d5d"
    },
    
	{
        "Index": "XFFT",
        "Title": "Xilinx Fast Fourier Transform - Float",
        "Version": "001",
        "Description": "Xilinx Fast Fourier Transform using IEEE-754 single precision floating-point",
        "Changelog": ["25.02.2021 Primary release"],
        "File": "xfft.bin",
        "Date": "25.02.2021",
        "Checksum": "93ad6fba86110791dc1158a868030e1d19c30130d4d962df8fa519ab552b34c6742b5f0abb7b0246b9e06eea2228385f057611bd35aff61cc9735307296b51e2"
    },
    
    {
        "Index": "XFFT_fixed",
        "Title": "Xilinx Fast Fourier Transform - Fixed",
        "Version": "001",
        "Description": "Xilinx Fast Fourier Transform using fixed-point",
        "Changelog": ["25.02.2021 Primary release"],
        "File": "xfft-fixed.bin",
        "Date": "25.02.2021",
        "Checksum": "8717db9c1ca38549470c76a1b613214d9fbd885bd53606378126dd01eb501613f5e97fc59fda34e9032beb642ba2b11ff7448c9665e484e85f560bc661d5ad48"
    },
        
    {
        "Index": "INTFFTK",
        "Title": "Fully pipelined integer unscaled FFT",
        "Version": "001",
        "Description": "Fully pipelined integer unscaled FFT",
        "Changelog": ["25.02.2021 Primary release"],
        "File": "intfftk.bin",
        "Date": "25.02.2021",
        "Checksum": "f00056cd8b41006a477193c8b9ee2c06d9d7e6346aa2ccb90588a25fb306c1b14e945f07a8c9d8c6d90574f5a5f2af3640a8a699880f26569fc9e1e91a2e51a6"
    },
    
    {
        "Index": "INTFFT_SPDF",
        "Title": "Integer unscaled Radix-2 Single Path Delay Feedback FFT",
        "Version": "001",
        "Description": "Integer unscaled Radix-2 Single Path Delay Feedback FFT",
        "Changelog": ["25.02.2021 Primary release"],
        "File": "intfft_spdf.bin",
        "Date": "25.02.2021",
        "Checksum": "fe844e4d0b589abd22896fb6a78d581366d323426642b3d83c284104600478c2b2b1c6815d82fe7862cde7b6cde0cd21b13fc1435139970893d93ef9b70a7357"
    },
    
    {
        "Index": "DBLCLKFFT",
        "Title": "Generic Pipelined FFT",
        "Version": "001",
        "Description": "Generic Pipelined FFT",
        "Changelog": ["25.02.2021 Primary release"],
        "File": "dblclkfft.bin",
        "Date": "25.02.2021",
        "Checksum": "79b7a77dc5e192929902ea60682cd33285c89246462793f441f4b16b91fe44f2f6f3b918106ba5db3f885e7558c546887a5b910f1b79b88b021e413e46e69389"
    },
    
    {
        "Index": "SDFT",
        "Title": "Software Discrete Fourier Transform",
        "Version": "001",
        "Description": "Software Discrete Fourier Transform, Implement Greybox module in hardware",
        "Changelog": ["25.02.2021 Primary release"],
        "File": "greybox.bin",
        "Date": "06.03.2021",
        "Checksum": "394f3d8eb9c8040d5232c32ed4fc3fa8ab288d2e4e79d4c1b1b8a6bcd01d758cb82545fc67626c264f374d38fefec0ca95e6f1735d9bf66d376ea9ca341d876e"
    },
    
    {
        "Index": "BLUE-FILTER",
        "Title": "IOT Image Processing",
        "Version": "001",
        "Description": "blue filter logic",
        "Changelog": ["03.10.2020 Primary release"],
        "File": "blue_filter.bin",
        "Date": "03.10.2020",
        "Checksum": "6c719309aacd88f3bbfc3ba57f454973e06c055540b444f76b4c863bb64229e7bcb3a7a53b715e05048e00babad05c76b917963efaa64ea09bfa4a0e21ebb2a7"
    },

    {
        "Index": "GREEN-FILTER",
        "Title": "IOT Image Processing",
        "Version": "015",
        "Description": "green filter logic",
        "Changelog": ["03.10.2020 Primary release"],
        "File": "green_filter.bin",
        "Date": "03.10.2020",
        "Checksum": "be2c812ac9624e48a41bbf611ca7448cdce49d18d391309b0061edded8ef9fbf6ac41f6a7d1a76d00aed44da376ba42229b2f3897726d56a4c948330b3cfe764"
    },
    
    {
        "Index": "SOC-LAB-IOT",
        "Title": "IOT Image Processing",
        "Version": "001",
        "Description": "red filter logic",
        "Changelog": ["03.10.2020 Primary release"],
        "File": "red_filter.bin",
        "Date": "03.10.2020",
        "Checksum": "9428bf2d56512845b52c1fc3cb9636acfca0ab53637982f788361abf86db9f93081fc51beda6d99c4212cbeaa0f6863626d89522c814f02af7f9688bfb4edfb4"
    }    
]

class Repository(Resource):
    def get(self, index):
        for repo in repositories:
            if index == repo["Index"]:
                return repo, 200
            else:
                continue
        return "Repository not found", 404

    def post(self, index):
        parser = reqparse.RequestParser()
        parser.add_argument("Title")
        parser.add_argument("Version")
        parser.add_argument("Description")
        parser.add_argument("Changelog")
        parser.add_argument("File")
        parser.add_argument("Date")
        parser.add_argument("Checksum")
        args = parser.parse_args()

        for repo in repositories:
            if index == repo["Index"]:
                return "Repository with index {} already exists".format(index), 400

        repo = {
            "Index": index,
            "Title": args["Title"],
            "Version": args["Version"],
            "Description": args["Description"],
            "Changelog": [args["Changelog"]],
            "File": args["File"],
            "Date": args["Date"],
            "Checksum": args["Checksum"]
        }

        repositories.append(repo)
        return repo, 201

    def put(self, index):
        parser = reqparse.RequestParser()
        parser.add_argument("Title")
        parser.add_argument("Version")
        parser.add_argument("Description")
        parser.add_argument("Changelog")
        parser.add_argument("File")
        parser.add_argument("Date")
        parser.add_argument("Checksum")
        args = parser.parse_args()

        for repo in repositories:
            if index == repo["Index"]:
                if args["Title"] is not None:
                    repo["Title"] = args["Title"]
                if args["Version"] is not None:
                    repo["Version"] = args["Version"]
                if args["Description"] is not None:
                    repo["Description"] = args["Description"]
                if args["Changelog"] is not None:
                    repo["Changelog"].append(args["Changelog"])
                if args["File"] is not None:
                    repo["File"] = args["File"]
                if args["Date"] is not None:
                    repo["Date"] = args["Date"]
                if args["Checksum"] is not None:
                    repo["Checksum"] = args["Checksum"]

                return repo, 200

        repo = {
            "Index": index,
            "Title": args["Title"],
            "Version": args["Version"],
            "Description": args["Description"],
            "Changelog": [args["Changelog"]],
            "File": args["File"],
            "Date": args["Date"],
            "Checksum": args["Checksum"]
        }

        repositories.append(repo)
        return repo, 201

    def delete(self, index):
        for repo in repositories:
            if index == repo["Index"]:
                repositories.remove(repo)
                return "Repository {} is deleted".format(index), 200
