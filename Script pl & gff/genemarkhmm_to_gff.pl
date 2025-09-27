#!/usr/bin/perl
use strict;
use warnings;

# Vérifier le nombre d'arguments
if (@ARGV != 2) {
    die "Usage: perl script.pl <input_file> <sequence_name>\n";
}

# Assigner les arguments à des variables
my $input_file = $ARGV[0];
my $sequence_name = $ARGV[1];

# Ouvre le fichier d'entrée
open my $fh, '<', $input_file or die "Impossible d'ouvrir le fichier : $!";

my @genes;  # Pour stocker les informations des gènes

# Lire le fichier ligne par ligne
while (my $line = <$fh>) {
    # Cherche la ligne qui commence par "Predicted genes"
    if ($line =~ /Predicted genes/) {
        # Ignore les lignes suivantes jusqu'à ce que les données commencent
        <$fh>; <$fh>; <$fh>;  # Ignore les trois lignes suivantes
        last;  # Sortir de la boucle
    }
}

# Lire les informations des gènes
while (my $line = <$fh>) {
    chomp $line;  # Supprimer le retour à la ligne
    last if $line =~ /^\)/;  # Arrête si on atteint la fin des données

    # Capture les données des gènes
    if ($line =~ /^\s*(\d+)\s+([+-])\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/) {
        my ($gene_number, $strand, $left_end, $right_end, $length, $class) = ($1, $2, $3, $4, $5, $6);
        
        # Stocker les données dans un tableau
        push @genes, {
            gene_number => $gene_number-1,
            strand => $strand,
            left_end => $left_end,
            right_end => $right_end,
            length => $length,
            class => $class,
        };
    }
}

# Génération des lignes GFF
foreach my $CDS (@genes) {
    my $gff_strand = $CDS->{strand};
    my $left_end = $CDS->{left_end};
    my $right_end = $CDS->{right_end};
    
    # Génère la ligne GFF pour le gène
    my $gff_line = "$sequence_name\tGeneMark\tCDS\t$left_end\t$right_end\t.\t$gff_strand\t.\tID=CDS_$CDS->{gene_number}\tLength=$CDS->{length}\tClass=$CDS->{class}";
    print "$gff_line\n";
}

# Ferme le fichier
close $fh;
