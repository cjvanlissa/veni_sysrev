# pDjRe9w.HNEEDsY!
wos <- function(tag){
  tags <- c(FN = "File Name", VR = "Version Number", PT = "Publication Type (J=Journal; B=Book; S=Series; P=Patent)", 
            AU = "Authors", AF = "Author Full Name", BA = "Book Authors", 
            BF = "Book Authors Full Name", CA = "Group Authors", GP = "Book Group Authors", 
            BE = "Editors", TI = "Document Title", SO = "Publication Name", 
            SE = "Book Series Title", BS = "Book Series Subtitle", LA = "Language", 
            DT = "Document Type", CT = "Conference Title", CY = "Conference Date", 
            CL = "Conference Location", SP = "Conference Sponsors", HO = "Conference Host", 
            DE = "Author Keywords", ID = "Keywords PlusÂ®", AB = "Abstract", 
            C1 = "Author Address", RP = "Reprint Address", EM = "E-mail Address", 
            RI = "ResearcherID Number", OI = "ORCID Identifier (Open Researcher and Contributor ID)", 
            FU = "Funding Agency and Grant Number", FX = "Funding Text", 
            CR = "Cited References", NR = "Cited Reference Count", TC = "Web of Science Core Collection Times Cited Count", 
            Z9 = "Total Times Cited Count (Web of Science Core Collection, BIOSIS Citation Index, Chinese Science Citation Database, Data Citation Index, Russian Science Citation Index, SciELO Citation Index)", 
            U1 = "Usage Count (Last 180 Days)", U2 = "Usage Count (Since 2013)", 
            PU = "Publisher", PI = "Publisher City", PA = "Publisher Address", 
            SN = "International Standard Serial Number (ISSN)", EI = "Electronic International Standard Serial Number (eISSN)", 
            BN = "International Standard Book Number (ISBN)", J9 = "29-Character Source Abbreviation", 
            JI = "ISO Source Abbreviation", PD = "Publication Date", PY = "Year Published", 
            VL = "Volume", IS = "Issue", SI = "Special Issue", PN = "Part Number", 
            SU = "Supplement", MA = "Meeting Abstract", BP = "Beginning Page", 
            EP = "Ending Page", AR = "Article Number", DI = "Digital Object Identifier (DOI)", 
            D2 = "Book Digital Object Identifier (DOI)", EA = "Early access date", 
            EY = "Early access year", PG = "Page Count", P2 = "Chapter Count (Book Citation Index)", 
            WC = "Web of Science Categories", SC = "Research Areas", GA = "Document Delivery Number", 
            PM = "PubMed ID", UT = "Accession Number", OA = "Open Access Indicator", 
            HP = "ESI Hot Paper. Note that this field is valued only for ESI subscribers.", 
            HC = "ESI Highly Cited Paper. Note that this field is valued only for ESI subscribers.", 
            DA = "Date this report was generated.", ER = "End of Record", 
            EF = "End of File")
  tags[tag]
}

wos_tags <- read.table("wos_tags", sep = "\t", stringsAsFactors = FALSE)
tmp <- wos_tags$V2
names(tmp) <- wos_tags$V1
dput(tmp)
dput(wos_tags$V1)
read_wos <- function(filename){
  out_tags <- c("FN", "VR", "PT", "AU", "AF", "BA", "BF", "CA", "GP", "BE", 
                "TI", "SO", "SE", "BS", "LA", "DT", "CT", "CY", "CL", "SP", "HO", 
                "DE", "ID", "AB", "C1", "RP", "EM", "RI", "OI", "FU", "FX", "CR", 
                "NR", "TC", "Z9", "U1", "U2", "PU", "PI", "PA", "SN", "EI", "BN", 
                "J9", "JI", "PD", "PY", "VL", "IS", "SI", "PN", "SU", "MA", "BP", 
                "EP", "AR", "DI", "D2", "EA", "EY", "PG", "P2", "WC", "SC", "GA", 
                "PM", "UT", "OA", "HP", "HC", "DA", "ER", "EF")
  regex_tag <- paste0("^(", paste0(out_tags, collapse = "|"), ") ")
  out_string <- rep(NA, length(out_tags))
  names(out_string) <- out_tags
  dat <- readLines(filename)
  locations <- grep("^PT ", dat)
  dat <- mapply(function(b, e){dat[b:e]}, b = locations, e = c((locations-1)[-1], length(dat)))
  dat <- lapply(dat, function(thisrec){
    #thisrec<-dat[[1]]
    locations <- grep(regex_tag, thisrec)
    tmp <- mapply(function(b, e){paste0(thisrec[b:e], collapse = "")}, b = locations, e = c((locations-1)[-1], length(thisrec)))
    these_tags <- substr(tmp, 1, 2)
    tmp <- substring(tmp, first = 4)
    out_string[match(these_tags, names(out_string))] <- tmp
    writeClipboard(out_string)
  })
  
  

  
  dat <- mapply(function(b, e){dat[b:e]}, b = which(names(dat) == "PT"), e = c((which(names(dat) == "PT")-1)[-1], length(dat)))
  tmp <- dat[[1]]
  tmp[3]
}

dat <- read_wos(filename = "savedrecs_full.txt")