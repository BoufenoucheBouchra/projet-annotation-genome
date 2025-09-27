#!/usr/bin/perl
use strict;
use warnings;

# Vérifier le nombre d'arguments
if (@ARGV != 3) {
    die "Usage: perl script.pl <input_file> <feature> <output_file>\n";
}

my ($input_file, $feature, $output_file) = @ARGV;

# Ouvre le fichier d'entrée
open my $fh_in, '<', $input_file or die "Impossible d'ouvrir le fichier d'entrée : $!";
# Ouvre le fichier de sortie
open my $fh_out, '>', $output_file or die "Impossible d'ouvrir le fichier de sortie : $!";

# Traitement du fichier d'entrée
while (my $line = <$fh_in>) {
    chomp $line;
    
    # Vérifie si la ligne commence par '>'
    if ($line =~ /^>(\S+):\[(\d+),(\d+)\]/) {
        my $sequence_name = $1;
        my $start_pos = $2;
        my $end_pos = $3;

        # Récupère la ligne suivante pour le motif
        my $motif_line = <$fh_in>;
        chomp $motif_line;

        # Génère la ligne GFF
        my $gff_line = join("\t", 
            $sequence_name,         # nomseq
            "Patscan",              # method
            $feature,               # feature (promoter, RBS, terminateur)
            $start_pos,             # posgauche
            $end_pos,               # posdroite
            ".",                    # score
            "+",                    # strand
            ".",                    # frame
            "note \"$motif_line\""  # note motif
        );

        # Écrit la ligne dans le fichier de sortie
        print $fh_out "$gff_line\n";
    }
}

# Ferme les fichiers
close $fh_in;
close $fh_out;

print "Parsing completed. Output written to $output_file.\n";