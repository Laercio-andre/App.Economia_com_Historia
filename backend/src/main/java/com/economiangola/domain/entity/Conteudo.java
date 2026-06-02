// src/main/java/com/economiangola/domain/entity/Conteudo.java
package com.economiangola.domain.entity;

import com.economiangola.domain.enums.StatusConteudo;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "conteudos")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Conteudo extends SoftDeletableEntity {

    @Column(name = "titulo", nullable = false, length = 255)
    private String titulo;

    @Column(name = "slug", nullable = false, unique = true, length = 300)
    private String slug;

    @Column(name = "resumo", length = 500)
    private String resumo;

    @Column(name = "corpo", columnDefinition = "TEXT")
    private String corpo;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    @Builder.Default
    private StatusConteudo status = StatusConteudo.RASCUNHO;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "autor_id", nullable = false)
    private Usuario autor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id", nullable = false)
    private Categoria categoria;

    @Column(name = "visualizacoes", nullable = false)
    @Builder.Default
    private Long visualizacoes = 0L;

    @OneToMany(mappedBy = "conteudo", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<ConteudoMidia> midias = new ArrayList<>();

    @OneToMany(mappedBy = "conteudo", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<ConteudoTag> tags = new ArrayList<>();

    @OneToMany(mappedBy = "conteudo", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Reacao> reacoes = new ArrayList<>();

    @OneToMany(mappedBy = "conteudo", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Comentario> comentarios = new ArrayList<>();
}
